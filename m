Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [Linux-nvdimm] [PATCH v2 19/20] nd_btt: atomic sector updates
Date: Sun, 17 May 2015 01:19:17 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A9097E5@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150428182557.35812.38292.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428182557.35812.38292.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Ingo Molnar <mingo@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, "Kani, Toshimitsu" <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>


> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dan Williams
> Sent: Tuesday, April 28, 2015 1:26 PM
> To: linux-nvdimm@lists.01.org
> Cc: Ingo Molnar; Neil Brown; Greg KH; Dave Chinner; linux-
> kernel@vger.kernel.org; Andy Lutomirski; Jens Axboe; H. Peter Anvin;
> Christoph Hellwig
> Subject: [Linux-nvdimm] [PATCH v2 19/20] nd_btt: atomic sector updates
> 
> From: Vishal Verma <vishal.l.verma@linux.intel.com>
> 
> BTT stands for Block Translation Table, and is a way to provide power
> fail sector atomicity semantics for block devices that have the ability
> to perform byte granularity IO. It relies on the ->rw_bytes() capability
> of provided nd namespace devices.
> 
> The BTT works as a stacked blocked device, and reserves a chunk of space
> from the backing device for its accounting metadata.  BLK namespaces may
> mandate use of a BTT and expect the bus to initialize a BTT if not
> already present.  Otherwise if a BTT is desired for other namespaces (or
> partitions of a namespace) a BTT may be manually configured.
...

Running btt above pmem with a variety of workloads, I see an awful lot 
of time spent in two places:
* _raw_spin_lock 
* btt_make_request

This occurs for fio to raw /dev/ndN devices, ddpt over ext4 or xfs,
cp -R of large directories, and running make on the linux kernel.

Some specific results:

fio 4 KiB random reads, WC cache type, memcpy:
* 43175 MB/s,   8 M IOPS  pmem0 and pmem1
* 18500 MB/s, 1.5 M IOPS  nd0 and nd1

fio 4 KiB random reads, WC cache type, memcpy with non-temporal
loads (when everything is 64-byte aligned):
* 33814 MB/s, 4.3 M IOPS  nd0 and nd1

Zeroing out 32 MiB with ddpt:
* 19 s, 1800 MiB/s	pmem
* 55 s,  625 MiB/s	btt

If btt_make_request needs to stall this much, maybe it'd be better
to utilize the blk-mq request queues, keeping requests in per-CPU
queues while they're waiting, and using IPIs for completion 
interrupts when they're finally done.


fio 4 KiB random reads without non-temporal memcpy
==================================================
perf top shows memcpy_erms taking all the time, a function that
uses 8-byte REP; MOVSB instructions:
 85.78%  [kernel]             [k] memcpy_erms
  1.21%  [kernel]             [k] _raw_spin_lock
  0.72%  [nd_btt]             [k] btt_make_request
  0.67%  [kernel]             [k] do_blockdev_direct_IO
  0.47%  fio                  [.] get_io_u

fio 4 KiB random reads with non-temporal memcpy
===============================================
perf top shows there are still quite a few unaligned accesses
resulting in legacy memcpy, but about equal time is now spent
in legacy vs NT memcpy:
 30.47%  [kernel]            [k] memcpy_erms
 26.27%  [kernel]            [k] memcpy_lnt_st_64
  5.37%  [kernel]            [k] _raw_spin_lock
  2.20%  [kernel]            [k] btt_make_request
  2.03%  [kernel]            [k] do_blockdev_direct_IO
  1.41%  fio                 [.] get_io_u
  1.22%  [kernel]            [k] btt_map_read
  1.15%  [kernel]            [k] pmem_rw_bytes
  1.01%  [kernel]            [k] nd_btt_rw_bytes
  0.98%  [kernel]            [k] nd_region_acquire_lane
  0.89%  fio                 [.] get_next_rand_block
  0.88%  fio                 [.] thread_main
  0.79%  fio                 [.] ios_completed
  0.76%  fio                 [.] td_io_queue
  0.75%  [kernel]            [k] _raw_spin_lock_irqsave
  0.68%  [kernel]            [k] kmem_cache_free
  0.66%  [kernel]            [k] kmem_cache_alloc
  0.59%  [kernel]            [k] __audit_syscall_exit
  0.57%  [kernel]            [k] aio_complete
  0.54%  [kernel]            [k] do_io_submit
  0.52%  [kernel]            [k] _raw_spin_unlock_irqrestore

fio randrw workload
===================
perf top shows that adding writes to the mix brings btt_make_request
its cpu_relax() loop to the forefront:
  21.09%  [nd_btt]                              [k] btt_make_request 
  19.06%  [kernel]                              [k] memcpy_erms  
  14.35%  [kernel]                              [k] _raw_spin_lock   
  10.38%  [nd_pmem]                             [k] memcpy_lnt_st_64    
   1.57%  [kernel]                              [k] do_blockdev_direct_IO   
   1.51%  [nd_pmem]                             [k] memcpy_lt_snt_64      
   1.43%  [nd_btt]                              [k] nd_btt_rw_bytes       
   1.39%  [kernel]                              [k] radix_tree_next_chunk  
   1.33%  [kernel]                              [k] put_page             
   1.21%  [nd_pmem]                             [k] pmem_rw_bytes      
   1.11%  fio                                   [.] get_io_u          
   0.90%  fio                                   [.] io_u_queued_complete  
   0.74%  [kernel]                              [k] system_call         
   0.72%  [libnd]                               [k] nd_region_acquire_lane   
   0.71%  [nd_btt]                              [k] btt_map_read            
   0.62%  fio                                   [.] thread_main           

inside btt_make_request:

       �                     /* Wait if the new block is being read from */
       �                     for (i = 0; i < arena->nfree; i++)
  2.98 �     ? je     2b4
  0.05 �       mov    0x60(%r14),%rax
  0.00 �       mov    %ebx,%edx
       �       xor    %esi,%esi
  0.03 �       or     $0x80000000,%edx
  0.05 �       nop
       �                             while (arena->rtt[i] == (RTT_VALID | new_postmap))
 22.98 �290:   mov    %esi,%edi
  0.01 �       cmp    %edx,(%rax,%rdi,4)
 30.97 �       lea    0x0(,%rdi,4),%rcx
 21.05 �     ? jne    2ab
       �       nop
       �     }
       �
       �     /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
       �     static inline void rep_nop(void)
       �     {
       �             asm volatile("rep; nop" ::: "memory");
       �2a0:   pause
       �       mov    0x60(%r14),%rax
       �       cmp    (%rax,%rcx,1),%edx
       �     ? je     2a0
       �                     }


ddpt zeroing out
================
perf top shows 27% in spinlocks, and 14% in btt_make_request (all in 
the "wait if the new block is being read from" loop).

  26.48%  [kernel]                      [k] _raw_spin_lock   
  14.46%  [nd_btt]                      [k] btt_make_request  
  13.14%  [kernel]                      [k] memcpy_erms    
  10.34%  [kernel]                      [k] copy_user_enhanced_fast_string 
   3.12%  [nd_pmem]                     [k] memcpy_lt_snt_64  
   1.15%  [kernel]                      [k] __block_commit_write.isra.21 
   0.96%  [nd_pmem]                     [k] pmem_rw_bytes 
   0.96%  [nd_btt]                      [k] nd_btt_rw_bytes 
   0.86%  [kernel]                      [k] unlock_page     
   0.65%  [kernel]                      [k] _raw_spin_lock_irqsave 
   0.58%  [kernel]                      [k] bdev_read_only 
   0.56%  [kernel]                      [k] release_pages  
   0.54%  [nd_pmem]                     [k] memcpy_lnt_st_64  
   0.53%  [ext4]                        [k] ext4_mark_iloc_dirty   
   0.52%  [kernel]                      [k] __wake_up_bit   
   0.52%  [kernel]                      [k] __clear_user   

---
Robert Elliott, HP Server Storage
