package org.lisaac.ldt.model.items;

import org.lisaac.ldt.model.types.IType;

public interface IArgument extends IVariable {

	String getName();

	IType getType();

	boolean hasName(String word);
	
	void printIn(StringBuffer buffer);
}
