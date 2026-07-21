package com.snowgears.shop.util;

import com.snowgears.shop.shop.AbstractShop;

import java.util.Comparator;

public class ComparatorShopItemNameLow implements Comparator<AbstractShop>{
	@Override
    public int compare(AbstractShop o1, AbstractShop o2) {
        String name1 = o1 != null && o1.getGuiIcon() != null && o1.getGuiIcon().getItemMeta() != null && o1.getGuiIcon().getItemMeta().getDisplayName() != null ? o1.getGuiIcon().getItemMeta().getDisplayName() : "";
        String name2 = o2 != null && o2.getGuiIcon() != null && o2.getGuiIcon().getItemMeta() != null && o2.getGuiIcon().getItemMeta().getDisplayName() != null ? o2.getGuiIcon().getItemMeta().getDisplayName() : "";
        return name1.compareTo(name2);
    }
}
