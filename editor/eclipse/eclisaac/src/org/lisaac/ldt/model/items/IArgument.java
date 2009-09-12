package org.lisaac.ldt.model.items;

import java.util.ArrayList;

import org.eclipse.jface.text.contentassist.ICompletionProposal;
import org.lisaac.ldt.model.types.IType;

public interface IArgument extends IVariable {

	String getName();

	IType getType();

	boolean hasName(String word);
	
	void printIn(StringBuffer buffer);

	void getMatchProposals(String n, ArrayList<ICompletionProposal> matchList,
			int offset, int length);
}
