package org.lisaac.ldt.model.items;

import java.util.List;

import org.eclipse.text.edits.DeleteEdit;
import org.eclipse.text.edits.InsertEdit;
import org.eclipse.text.edits.TextEdit;
import org.lisaac.ldt.model.LisaacParser;
import org.lisaac.ldt.model.Position;
import org.lisaac.ldt.model.types.IType;

public class ITMList implements ICode {
	protected ICode[] code;
	protected ITMLocal[] localList;
	protected ITMLocal[] staticList;

	protected int startOffset, endOffset;
	
	private Slot owner;
	
	public ITMList(Slot slot, int start) {
		startOffset = start;
		endOffset = startOffset;
		owner = slot;
		if (slot != null) {
			slot.addSubList(this);
		}
	}
	
	public Slot getOwner() {
		return owner;
	}
	
	public void setEndOffset(int end) {
		endOffset = end;
	}

	public void setCode(ICode[] code) {
		this.code = code;
	}

	public void setLocalList(ITMLocal[] list) {
		localList = list;
	}
	public void setStaticList(ITMLocal[] list) {
		staticList = list;
	}

	public boolean hasVariableDefinition(String word) {		
		return getLocal(word) != null;
	}

	public ITMLocal getLocal(String word) {		
		if (localList != null) {
			for (int i=0; i<localList.length; i++) {
				if (localList[i].name.compareTo(word) == 0) {
					return localList[i];
				}
			}
		}
		if (staticList != null) {
			for (int i=0; i<staticList.length; i++) {
				if (staticList[i].name.compareTo(word) == 0) {
					return staticList[i];
				}
			}
		}
		return null;
	}
	
	public String getLocalMatch(String n) {
		if (localList != null) {
			for (int i=0; i<localList.length; i++) {
				if (localList[i].name.startsWith(n)) {
					return localList[i].name;
				}
			}
		}
		if (staticList != null) {
			for (int i=0; i<staticList.length; i++) {
				if (staticList[i].name.startsWith(n)) {
					return staticList[i].name;
				}
			}
		}
		return null;
	}
	
	public IType getType(Slot slot, Prototype prototype) {
		if (code != null && code.length > 0) {
			return code[code.length-1].getType(slot, prototype); // FIXME list type
		}
		return null;
	}
	
	public boolean isInside(int offset) {
		return offset >= startOffset && offset <= endOffset;
	}

	public void refactorRenamePrototype(String oldName, String newName, List<TextEdit> edits) {
		if (localList != null && owner != null) {
			for (int i=0; i<localList.length; i++) {
				createEdit(localList[i], oldName, newName, edits);
			}
		}
		if (staticList != null && owner != null) {
			for (int i=0; i<staticList.length; i++) {
				createEdit(staticList[i], oldName, newName, edits);
			}
		}
		if (code != null) {
			for (int i=0; i<code.length; i++) { 
				code[i].refactorRenamePrototype(oldName, newName, edits);
			}
		}
	}
	
	private void createEdit(ITMLocal local, String oldName, String newName, List<TextEdit> edits) {
		IType type = local.getType();
		Position p = local.getPosition();
		
		if (p != null && type.toString().compareTo(oldName) == 0) {
			LisaacParser parser = owner.getPrototype().openParser();
			parser.setPosition(p.offset+p.length);
			parser.readCharacter(':');
			parser.readSpace();
			
			int startOffset = parser.getOffset();
			
			edits.add(new DeleteEdit(startOffset, oldName.length()));
			edits.add(new InsertEdit(startOffset, newName));
		}
	}
}
