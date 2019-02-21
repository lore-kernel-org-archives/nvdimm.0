Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C738211CCD64
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 15:50:58 -0800 (PST)
Subject: Re: question about page tables in DAX/FS/PMEM case
References: <20190220230622.GI19341@ubuette>
 <20190221204141.GB5201@redhat.com> <20190221225827.GA2764@ubuette>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <6e4a5296-0ad0-ab1e-40a0-c1f69d11300a@intel.com>
Date: Thu, 21 Feb 2019 15:51:05 -0800
MIME-Version: 1.0
In-Reply-To: <20190221225827.GA2764@ubuette>
Content-Language: en-US
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
To: Larry Bassel <larry.bassel@oracle.com>, Jerome Glisse <jglisse@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 2/21/19 2:58 PM, Larry Bassel wrote:
> AFAIK there is no hardware benefit from sharing the page table
> directory within different page table. So the only benefit is the
> amount of memory we save.

The hardware benefit from schemes like this is that the CPU caches are
better utilized.  If two processes share page tables, they don't share
TLB entries, but they *do* share the contents of the CPU's caches.  That
will make TLB misses faster.

It probably doesn't matter *that* much in practice because the page
walker doing TLB fills does a pretty good job of hiding all the latency,
but it might matter in extreme cases.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
