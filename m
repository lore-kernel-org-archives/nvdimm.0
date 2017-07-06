Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80CD120958977
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 16:28:33 -0700 (PDT)
Subject: Re: [RFC v2 0/5] surface heterogeneous memory performance information
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
 <20170706230803.GE2919@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <e85da2ef-88bd-18f9-8b92-b64875d98a8b@intel.com>
Date: Thu, 6 Jul 2017 16:30:08 -0700
MIME-Version: 1.0
In-Reply-To: <20170706230803.GE2919@redhat.com>
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
To: Jerome Glisse <jglisse@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Box, David E" <david.e.box@intel.com>, linux-mm@kvack.org, "Zheng, Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, devel@acpica.org, "Kogut, Jaroslaw  <Jaroslaw.Kogut@intel.com>, Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, "Lahtinen, Joonas" <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 07/06/2017 04:08 PM, Jerome Glisse wrote:
>> So, for applications that need to differentiate between memory ranges based
>> on their performance, what option would work best for you?  Is the local
>> (initiator,target) performance provided by patch 5 enough, or do you
>> require performance information for all possible (initiator,target)
>> pairings?
> 
> Am i right in assuming that HBM or any faster memory will be relatively small
> (1GB - 8GB maybe 16GB ?) and of fix amount (ie size will depend on the exact
> CPU model you have) ?

For HBM, that's certainly consistent with the Xeon Phi MCDRAM.

But, please remember that this patch set is for fast memory *and* slow
memory (vs. plain DRAM).

> If so i am wondering if we should not restrict NUMA placement policy for such
> node to vma only. Forbid any policy that would prefer those node globally at
> thread/process level. This would avoid wide thread policy to exhaust this
> smaller pool of memory.

You would like to take the NUMA APIs and bifurcate them?  Make some of
them able to work on this memory, and others not?  So, set_mempolicy()
would work if you passed it one of these "special" nodes with
MPOL_F_ADDR, but would fail otherwise?


> Drawback of doing so would be that existing applications would not benefit
> from it. So workload where is acceptable to exhaust such memory wouldn't
> benefit until their application are updated.

I think the guys running 40-year-old fortran binaries might not be so
keen on this restriction.  I bet there are a pretty substantial number
of folks out there that would love to get new hardware and just do:

	numactl --membind=fast-node ./old-binary

If I were working for a hardware company, I'd sure like to just be able
to sell somebody some fancy new hardware and have their existing
software "just work" with a minimal wrapper.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
