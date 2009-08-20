package org.lisaac.ldt.model;


import java.util.ArrayList;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.text.contentassist.CompletionProposal;
import org.eclipse.jface.text.contentassist.ICompletionProposal;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.IWorkbenchWindow;
import org.lisaac.ldt.LisaacPlugin;
import org.lisaac.ldt.editors.LisaacEditor;
import org.lisaac.ldt.model.items.IArgument;
import org.lisaac.ldt.model.items.ICode;
import org.lisaac.ldt.model.items.ITMArgs;
import org.lisaac.ldt.model.items.ITMList;
import org.lisaac.ldt.model.items.ITMLocal;
import org.lisaac.ldt.model.items.ITMRead;
import org.lisaac.ldt.model.items.Prototype;
import org.lisaac.ldt.model.items.Slot;
import org.lisaac.ldt.model.types.IType;
import org.lisaac.ldt.model.types.TypeSelf;
import org.lisaac.ldt.outline.OutlineImages;

public class LisaacCompletionParser extends LisaacParser {
	protected static LisaacModel model;

	protected Prototype currentPrototype;
	protected Slot currentSlot;

	protected int endOffset;



	public LisaacCompletionParser(String contents, LisaacModel model) {
		super(null,contents);
		LisaacCompletionParser.model = model;
	} 

	/**
	 * Get the lisaac completions at baseOffset
	 * @param startOffset start offset for completion parsing
	 * @param baseOffset completion offset 
	 * @param proposals list of proposals to be filled  
	 * @throws CoreException
	 */
	public void parseCompletions(int startOffset, int baseOffset, ArrayList<ICompletionProposal> proposals)
	throws CoreException {
		IType type;

		currentPrototype = LisaacModel.getCurrentPrototype();
		currentSlot = currentPrototype.getSlot(startOffset);
		endOffset = -1;

		// keyword match
		while (readKeyword()) {
			if (baseOffset != (startOffset+position)) {
				continue;// not last keyword
			}
			String[] keywords = ILisaacModel.keywords;
			for (int i = 0; i < keywords.length; i++) {
				if (keywords[i].startsWith(lastString)) {// length(keyword[i]) >= length(lastString)
					String keywordCompletion = keywords[i].substring(lastString.length());
					proposals.add(new CompletionProposal(keywordCompletion,
							baseOffset, 0, keywordCompletion.length(),
							OutlineImages.KEYWORD, keywords[i], null, ""));
				}
			}
			return;
		}
		setPosition(0);
		
		// slot match
		ICode code = readExpr();
		if (code != null && currentPrototype != null) {
			type = code.getType(currentSlot, currentPrototype);
			if (type != null) {
				//if (! type.equals(TypeSimple.getTypeSelf())) {
				//if ("SELF".compareTo(type.toString()) != 0) {
				if (type instanceof TypeSelf) {
					currentPrototype = findPrototype(((TypeSelf) type).getStaticType());
				} else {
					currentPrototype = findPrototype(type.toString());
				}
				if (currentPrototype != null) {
					currentPrototype.getSlotProposals(proposals, baseOffset, 0);
					proposals.add(new CompletionProposal(""+type,baseOffset,0,0));
				} else {
					// partial prototype name
					String prefix = type.toString();
					model.getPathManager().getPathMatch(prefix, proposals, baseOffset);
				}
			} else {
				// partial name, search for matches
				if (code instanceof ITMRead) {
					String prefix = ((ITMRead) code).getName();
					
					// partial local name
					if (currentSlot != null) {
						currentSlot.getArgumentMatchProposals(prefix, proposals, baseOffset, 0);
						currentSlot.getLocalMatchProposals(prefix, proposals, baseOffset, 0);
					}
					// partial slot name (first keyword)
					currentPrototype.lookupSlotMatch(prefix, proposals, baseOffset, 0);
				}
			}
		} 
	}

	//++ EXPR_MESSAGE -> EXPR_BASE { '.' SEND_MSG }
	protected ICode readExprMessage() {

		ICode result = readExprBase();
		if (result != null) {
			while (readCharacter('.')) {
				if (endOffset != -1 && position == endOffset+1) {
					break;
				}
				ICode lastResult = result;
				result = readSendMsg(result);
				if (result == null) {
					return lastResult;
				}
				// update source of completion
				IType type = lastResult.getType(currentSlot, currentPrototype);
				//if (type != null && ! type.equals(TypeSimple.getTypeSelf())) {
				if (type != null && "SELF".compareTo(type.toString()) != 0) {
					try {
						currentPrototype = findPrototype(type.toString());
					} catch(CoreException e) {
						return null;
					}
					if (currentPrototype == null) {
						return null;
					}
					if (result instanceof ITMRead) {
						currentSlot = currentPrototype.lookupSlot(((ITMRead) result).getName());
					} else {
						currentSlot = null;
					}
				}
			}
		}
		return result;
	}


	public Prototype readReceiver(int startOffset, int endOffset, Prototype currentPrototype) throws CoreException {
		Prototype result=null;
		IType type;

		this.currentPrototype = currentPrototype;//LisaacModel.getCurrentPrototype();
		currentSlot = currentPrototype.getSlot(startOffset);
		this.endOffset = endOffset;

		setPosition(startOffset);
		readSpace();

		ICode code = readExpr();
		if (code != null && currentPrototype != null) {
			type = code.getType(currentSlot, currentPrototype);
			if (type != null) {
				//if (! type.equals(TypeSimple.getTypeSelf())) {
				if (type.toString() != null && "SELF".compareTo(type.toString()) != 0) {
					Prototype save = currentPrototype;
					currentPrototype = findPrototype(type.toString());
					if (currentPrototype == null) {
						currentPrototype = save;
					}
				}
				result = currentPrototype;	
			}
		}
		return result;
	}

	/**
	 * Find and parse a lisaac prototype according to its name.
	 */
	public static Prototype findPrototype(String prototypeName) throws CoreException {
		IProject project = null;

		if (model == null) {
			IWorkbenchWindow w = LisaacPlugin.getDefault().getWorkbench().getActiveWorkbenchWindow();
			if (w == null) {
				return null;
			} 
			IWorkbenchPart part = w.getPartService().getActivePart();
			if (part instanceof LisaacEditor) {
				project = ((LisaacEditor)part).getProject();
			}
			if (project != null) {
				model = LisaacModel.getModel(project);
			}
		}
		if (model == null) {
			return null;
		}
		if (project == null) {
			project = model.getProject();
		}
		return model.getPrototype(prototypeName);
	}
}
