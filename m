Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11DDA210BFF6A
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 11:00:41 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: caching options
Date: Thu, 2 Aug 2018 18:00:39 +0000
Message-ID: <AT5PR8401MB1169EBD36A1A522F587A3A1CAB2C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAKccVaykLyVKGuMpD8d1xABnsTzv+o=qt2ovnp1BXQHe0dnfHA@mail.gmail.com>
In-Reply-To: <CAKccVaykLyVKGuMpD8d1xABnsTzv+o=qt2ovnp1BXQHe0dnfHA@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Brian Stark <brian.stark@sanmina.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> Brian Stark
> Sent: Tuesday, July 31, 2018 11:43 AM
> To: linux-nvdimm@lists.01.org
> Subject: caching options
> 
> I have a customer that requires persistent memory be set to Write
> Combining cache attribute with the Skylake processor.  Is Write
> Combining for persistent memory supported in Linux?
> 
> Brian Stark

There's no API for applications to specify that right now.

You can recompile the kernel with this patch:

$ git diff
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 097072c5a852..d3f165d9ed77 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -206,7 +206,7 @@ int nvdimm_has_flush(struct nd_region *nd_region);
int nvdimm_has_cache(struct nd_region *nd_region);

#ifdef CONFIG_ARCH_HAS_PMEM_API
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WC
void arch_wb_cache_pmem(void *addr, size_t size);
void arch_invalidate_pmem(void *addr, size_t size);
#else

to cause persistent memory ranges used in "raw mode" to be marked as
write-combining rather than writeback cacheable. 

The other modes (sector, fsdax, and devdax) require different patches,
as the kernel maps memory differently for them.

You can confirm the write-combining settings if:
* the kernel is compiled with CONFIG_DEBUG_FS
* the debug filesystem is mounted with mount -t debugfs debugfs /sys/kernel/debug

$ sudo cat /sys/kernel/debug/x86/pat_memtype_list
PAT memtype list:
...
write-combining @ 0x880000000-0xa80000000
write-combining @ 0xa80000000-0xc80000000
...

The persistent memory addresses are reported in /proc/iomem
(e.g., starting at 0x880000000 on my test system).  

---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
