package org.lisaac.ldt.outline;

import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.swt.graphics.Image;

public class OutlineLabelProvider extends LabelProvider  {
	
	/**
     * @see WorkbenchLabelProvider#getImage(Object)
     * @param element the element for which an image is created
     * @return the image associated to the element
     */
    public Image getImage(Object element) {
        if (element instanceof OutlineItem) {
            OutlineItem item = (OutlineItem) element;
            Image image = item.getImage();
            
            if (image != null) {
                return image;
            }
        }
        return OutlineImages.BLANK;
    }

    /**
     * @see WorkbenchLabelProvider#getText(Object)
     * @param element the element for which a label is created
     * @return the label associated to the element
     */
    public String getText(Object element) {
        if (element instanceof OutlineItem) {
            OutlineItem item = (OutlineItem) element;
            return item.getText();
        }
        if (element != null) {
            return element.toString();
        } else {
            return new String();
        }
    }
}
