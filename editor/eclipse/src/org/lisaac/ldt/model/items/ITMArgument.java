package org.lisaac.ldt.model.items;

import org.lisaac.ldt.model.Position;
import org.lisaac.ldt.model.types.IType;
import org.lisaac.ldt.model.types.ITypeMono;

public class ITMArgument implements IArgument {
	
	protected String name;
	protected ITypeMono type;
	
	protected Position position;
	
	public ITMArgument(String name, ITypeMono type, Position position) {
		this.name = name;
		this.type = type;
		this.position = position;
	}

	public String getName() {
		return name;
	}

	public IType getType() {
		return type;
	}
	
	public boolean hasName(String word) {
		return name.compareTo(word) == 0;
	}
	
	public void printIn(StringBuffer buffer) {
		buffer.append(name);
		buffer.append(':');
		buffer.append(type);
	}
	
	public String getHoverInformation() {
		StringBuffer buffer = new StringBuffer();
		buffer.append("<I>Argument</I> : <b>");
		buffer.append(name);
		buffer.append("</b> <g> : ");
		buffer.append(type.toString());
		buffer.append("</g>");
		
		return buffer.toString();
	}

	public Position getPosition() {
		return position;
	}
}
