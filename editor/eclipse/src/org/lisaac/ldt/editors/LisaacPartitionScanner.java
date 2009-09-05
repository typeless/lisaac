package org.lisaac.ldt.editors;

import org.eclipse.jface.text.rules.*;

/**
 * Define rules to allow document partitioning.<br>
 * We have two types of partition: lisaac code and lisaac comments.
 */
public class LisaacPartitionScanner extends RuleBasedPartitionScanner {
	public final static String LISAAC_COMMENT = "__lisaac_comment";
	public final static String LISAAC_STRING = "__lisaac_string";
	public final static String LISAAC_EXTERNAL = "__lisaac_external";
	public final static String LISAAC_DEFAULT = "__lisaac_default";

	public LisaacPartitionScanner() {
		/*
		 * Define rules to identify comment partition, the rest of documents is default partition
		 */
		IToken comment = new Token(LISAAC_COMMENT);
		IToken string = new Token(LISAAC_STRING);
		IToken external = new Token(LISAAC_EXTERNAL);
		
		IPredicateRule[] rules = new IPredicateRule[6];

		rules[0] = new MultiLineRule("\"", "\"", string);
		rules[1] = new MultiLineRule("`", "`", external);
		
		rules[2] = new MultiLineRule("/*", "*/", comment);
		rules[3] = new EndOfLineRule("//", comment);
		
		// avoid processing comment inside lisaac strings
		rules[4] = new MultiLineRule("\"", "\"", string, '\0', true);
		rules[5] = new SingleLineRule("`", "`", external, '\0', true);
		
		setPredicateRules(rules);
	}
}
