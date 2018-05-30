Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E701A210C997B
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 12:55:14 -0700 (PDT)
Date: Thu, 31 May 2018 03:54:21 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 03/11] device-dax: enable page_mapping()
Message-ID: <201805310306.5o2l7Hgz%fengguang.wu@intel.com>
References: <152699998750.24093.5270058390086110946.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <152699998750.24093.5270058390086110946.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Disposition: inline
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: tony.luck@intel.com, linux-nvdimm@lists.01.org, linux-mm@kvack.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.17-rc7 next-20180530]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/mm-Teach-memory_failure-about-ZONE_DEVICE-pages/20180525-035652
config: arm64-allmodconfig (attached as .config)
compiler: aarch64-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=arm64 

All errors (new ones prefixed by >>):

   drivers//dax/device.c: In function 'dev_dax_huge_fault':
>> drivers//dax/device.c:413:8: error: too many arguments to function '__dev_dax_pud_fault'
      rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
           ^~~~~~~~~~~~~~~~~~~
   drivers//dax/device.c:380:19: note: declared here
    static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
                      ^~~~~~~~~~~~~~~~~~~

vim +/__dev_dax_pud_fault +413 drivers//dax/device.c

   386	
   387	static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
   388			enum page_entry_size pe_size)
   389	{
   390		struct vm_area_struct *vma = vmf->vma;
   391		struct file *filp = vma->vm_file;
   392		unsigned long fault_size;
   393		int rc, id;
   394		pfn_t pfn;
   395		struct dev_dax *dev_dax = filp->private_data;
   396	
   397		dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
   398				(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
   399				vma->vm_start, vma->vm_end, pe_size);
   400	
   401		id = dax_read_lock();
   402		switch (pe_size) {
   403		case PE_SIZE_PTE:
   404			fault_size = PAGE_SIZE;
   405			rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
   406			break;
   407		case PE_SIZE_PMD:
   408			fault_size = PMD_SIZE;
   409			rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
   410			break;
   411		case PE_SIZE_PUD:
   412			fault_size = PUD_SIZE;
 > 413			rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
   414			break;
   415		default:
   416			rc = VM_FAULT_SIGBUS;
   417		}
   418	
   419		if (rc == VM_FAULT_NOPAGE) {
   420			unsigned long i;
   421	
   422			for (i = 0; i < fault_size / PAGE_SIZE; i++) {
   423				struct page *page;
   424	
   425				page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
   426				if (page->mapping)
   427					continue;
   428				page->mapping = filp->f_mapping;
   429			}
   430		}
   431		dax_read_unlock(id);
   432	
   433		return rc;
   434	}
   435	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
