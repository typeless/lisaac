package org.lisaac.ldt.editors;

import org.eclipse.jface.text.rules.*;


/**
 * Define rules to allow document partitioning.<br>
 * We have two types of partition: lisaac code and lisaac comments.
 */

class LisaacPartitionScanner  extends RuleBasedPartitionScanner {
	public final static String LISAAC_COMMENT = "__lisaac_comment";
	public final static String LISAAC_STRING = "__lisaac_string";
	public final static String LISAAC_EXTERNAL = "__lisaac_external";
	public final static String LISAAC_DEFAULT = "__lisaac_default";

	public LisaacPartitionScanner() {

		IToken comment = new Token(LISAAC_COMMENT);
		IToken string = new Token(LISAAC_STRING);
		IToken external = new Token(LISAAC_EXTERNAL);

		IPredicateRule[] rules = new IPredicateRule[4];

		rules[0] = new MultiLineRule("\"", "\"", string, '\\');
		rules[1] = new MultiLineRule("`", "`", external, '\\');

		rules[2] = new MultiLineRule("/*", "*/", comment);
		rules[3] = new EndOfLineRule("//", comment);

		setPredicateRules(rules);
	}
}

