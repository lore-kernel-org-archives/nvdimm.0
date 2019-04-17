Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 569CF211F35CA
 for <linux-nvdimm@lists.01.org>; Wed, 17 Apr 2019 15:03:33 -0700 (PDT)
Date: Wed, 17 Apr 2019 15:03:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6 00/12] mm: Sub-section memory hotplug support
Message-Id: <20190417150331.90219ca42a1c0db8632d0fd5@linux-foundation.org>
In-Reply-To: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
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
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 17 Apr 2019 11:38:55 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> The memory hotplug section is an arbitrary / convenient unit for memory
> hotplug. 'Section-size' units have bled into the user interface
> ('memblock' sysfs) and can not be changed without breaking existing
> userspace. The section-size constraint, while mostly benign for typical
> memory hotplug, has and continues to wreak havoc with 'device-memory'
> use cases, persistent memory (pmem) in particular. Recall that pmem uses
> devm_memremap_pages(), and subsequently arch_add_memory(), to allocate a
> 'struct page' memmap for pmem. However, it does not use the 'bottom
> half' of memory hotplug, i.e. never marks pmem pages online and never
> exposes the userspace memblock interface for pmem. This leaves an
> opening to redress the section-size constraint.

v6 and we're not showing any review activity.  Who would be suitable
people to help out here?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
