Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CEB111A1DF1
 for <linux-nvdimm@lists.01.org>; Sun, 11 Sep 2016 20:45:00 -0700 (PDT)
From: "Rudoff, Andy" <andy.rudoff@intel.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Date: Mon, 12 Sep 2016 03:44:59 +0000
Message-ID: <E987E30D-5C68-420C-B68D-7E0AAA7F2303@intel.com>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com>
 <CAPcyv4h5y4MHdXtdrdPRtG7L0_KCoxf_xwDGnHQ2r5yZoqkFzQ@mail.gmail.com>
 <5d5ef209-e005-12c6-9b34-1fdd21e1e6e2@linux.intel.com>
In-Reply-To: <5d5ef209-e005-12c6-9b34-1fdd21e1e6e2@linux.intel.com>
Content-Language: en-US
Content-ID: <76885E75BDC24242BEF18F4F486DC627@intel.com>
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
To: Xiao Guangrong <guangrong.xiao@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Gleb Natapov <gleb@kernel.org>, "mtosatti@redhat.com" <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, Yumei Huang <yuhuang@redhat.com>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

>Whether msync/fsync can make data persistent depends on ADR feature on
>memory controller, if it exists everything works well, otherwise, we need
>to have another interface that is why 'Flush hint table' in ACPI comes
>in. 'Flush hint table' is particularly useful for nvdimm virtualization if
>we use normal memory to emulate nvdimm with data persistent characteristic
>(the data will be flushed to a persistent storage, e.g, disk).
>
>Does current PMEM programming model fully supports 'Flush hint table'? Is
>userspace allowed to use these addresses?

The Flush hint table is NOT a replacement for ADR.  To support pmem on
the x86 architecture, the platform is required to ensure that a pmem
store flushed from the CPU caches is in the persistent domain so that the
application need not take any additional steps to make it persistent.
The most common way to do this is the ADR feature.

If the above is not true, then your x86 platform does not support pmem.

Flush hints are for use by the BIOS and drivers and are not intended to
be used in user space.  Flush hints provide two things:

First, if a driver needs to write to command registers or movable windows
on a DIMM, the Flush hint (if provided in the NFIT) is required to flush
the command to the DIMM or ensure stores done through the movable window
are complete before moving it somewhere else.

Second, for the rare case where the kernel wants to flush stores to the
smallest possible failure domain (i.e. to the DIMM even though ADR will
handle flushing it from a larger domain), the flush hints provide a way
to do this.  This might be useful for things like file system journals to
help ensure the file system is consistent even in the face of ADR failure.

-andy


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
