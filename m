Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: xfs over pmem - cp performance
Date: Fri, 8 Jan 2016 21:07:27 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BF0881D@G4W3202.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

I tried using cp to copy the linux git tree between
pmem devices like this:
                cp -r /mnt/xfs-pmem1/linux /mnt/xfs-pmem2

The time taken by various filesystems varies (4.4-rc5):
* xfs    w/dax: 42 s
* xfs   no dax: 14 s
* ext4   w/dax:  7 s
* ext4  no dax: 15 s
* btrfs no dax: 18 s

mount options:
* /dev/pmem1 on /mnt/xfs-pmem1 type xfs (rw,relatime,seclabel,attr2,dax,inode64,noquota)
* /dev/pmem1 on /mnt/ext4-pmem1 type ext4 (rw,relatime,seclabel,dax,data=ordered)
* /dev/pmem1 on /mnt/btrfs-pmem1 type btrfs (rw,relatime,seclabel,ssd,space_cache,subvolid=5,subvol=/)

xfs with dax spends most of the time in clear_page_c_e and
dax-clear_blocks (from "perf top"): 
  30.06%  [kernel]            [k] clear_page_c_e        
  12.24%  [kernel]            [k] dax_clear_blocks      
   5.36%  [kernel]            [k] copy_user_enhanced_fast_string
   4.33%  [kernel]            [k] __copy_user_nocache   
   2.55%  [xfs]               [k] xfs_perag_put         
   1.77%  [kernel]            [k] security_compute_sid.part.12  
   1.19%  [kernel]            [k] __percpu_counter_sum  
   1.14%  [kernel]            [k] acpi_os_write_port    
   1.03%  [kernel]            [k] dax_do_io             
   1.00%  [kernel]            [k] _raw_spin_lock        

The others spend most of their time in the 
copy_user_enhanced_fast_string and __copy_user_nocache 
functions that actually copy data.

xfs without dax:
  28.82%  [kernel]            [k] copy_user_enhanced_fast_string
   7.48%  [kernel]            [k] __copy_user_nocache
   3.63%  [kernel]            [k] __block_commit_write.isra.22
   1.86%  [kernel]            [k] acpi_os_write_port
   1.72%  [kernel]            [k] filenametr_cmp
   1.48%  [kernel]            [k] hashtab_search
   1.28%  [kernel]            [k] security_compute_sid.part.12
   0.96%  [kernel]            [k] _raw_spin_lock

ext4 with dax:
  22.85%  [kernel]             [k] __copy_user_nocache
  22.51%  [kernel]             [k] copy_user_enhanced_fast_string
   4.15%  [kernel]             [k] mb_find_order_for_block
   3.03%  [kernel]             [k] dax_do_io
   2.08%  [kernel]             [k] __d_lookup_rcu
   1.85%  [kernel]             [k] mb_find_extent
   1.75%  [kernel]             [k] ext4_mark_iloc_dirty
   1.54%  [kernel]             [k] acpi_os_write_port
   1.15%  [kernel]             [k] _find_next_bit.part.0
   0.99%  [kernel]             [k] ext4_mb_good_group

ext4 without dax:
  29.89%  [kernel]            [k] copy_user_enhanced_fast_string
  15.81%  [kernel]            [k] __copy_user_nocache
   4.45%  [kernel]            [k] __block_commit_write.isra.22
   1.39%  [kernel]            [k] ext4_mark_iloc_dirty
   1.37%  [kernel]            [k] ext4_bio_write_page
   1.12%  [kernel]            [k] filenametr_cmp
   1.09%  [kernel]            [k] security_compute_sid.part.12
   0.98%  [kernel]            [k] hashtab_search

btrfs (without dax):
  14.25%  [kernel]            [k] copy_user_enhanced_fast_string
  14.12%  [kernel]            [k] queued_spin_lock_slowpath
   9.70%  [kernel]            [k] __copy_user_nocache
   3.48%  [kernel]            [k] acpi_os_write_port
   1.52%  [kernel]            [k] _raw_spin_lock
   1.38%  [kernel]            [k] queued_write_lock_slowpath
   1.36%  [kernel]            [k] _raw_spin_lock_irqsave

---
Robert Elliott, HPE Persistent Memory


