Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 33DFC21959CB2
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 13:56:51 -0700 (PDT)
Date: Thu, 4 Apr 2019 14:58:18 -0600
From: Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH 3/5] acpi/hmat: Track target address ranges
Message-ID: <20190404205818.GC24499@localhost.localdomain>
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440492414.3190322.12683374224345847860.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155440492414.3190322.12683374224345847860.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 04, 2019 at 12:08:44PM -0700, Dan Williams wrote:
> As of ACPI 6.3 the HMAT no longer advertises the physical memory address
> range for its entries. Instead, the expectation is the corresponding
> entry in the SRAT is looked up by the target proximity domain.
> 
> Given there may be multiple distinct address ranges that share the same
> performance profile (sparse address space), find_mem_target() is updated
> to also consider the start address of the memory range. Target property
> updates are also adjusted to loop over all possible 'struct target'
> instances that may share the same proximity domain identification.

Since this may allocate multiple targets with the same PXM,
hmat_register_targets() will attempt to register the same node multiple
times.

Would it make sense if the existing struct memory_target adds a resource
list that we can append to as we parse SRAT? That way we have one target
per memory node, and also track the ranges.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
