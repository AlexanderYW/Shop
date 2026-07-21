package com.snowgears.shop.util;

import net.md_5.bungee.api.ChatColor;
import org.bukkit.inventory.ItemStack;

import java.util.Comparator;

public class ComparatorItemstackName implements Comparator<ItemStack>{
	@Override
    public int compare(ItemStack o1, ItemStack o2) {
        String name1 = o1 != null && o1.getItemMeta() != null && o1.getItemMeta().getDisplayName() != null ? ChatColor.stripColor(o1.getItemMeta().getDisplayName()) : "";
        String name2 = o2 != null && o2.getItemMeta() != null && o2.getItemMeta().getDisplayName() != null ? ChatColor.stripColor(o2.getItemMeta().getDisplayName()) : "";
        return name1.compareTo(name2);
    }
}
