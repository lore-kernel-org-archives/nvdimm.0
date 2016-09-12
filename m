Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FF8B1A1E0A
 for <linux-nvdimm@lists.01.org>; Sun, 11 Sep 2016 23:05:53 -0700 (PDT)
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com>
 <CAPcyv4h5y4MHdXtdrdPRtG7L0_KCoxf_xwDGnHQ2r5yZoqkFzQ@mail.gmail.com>
 <5d5ef209-e005-12c6-9b34-1fdd21e1e6e2@linux.intel.com>
 <CAPcyv4ibiZG3SkW0TZywn8Qovo3hpxBqs4wCfw1DFEbbE=1-Mg@mail.gmail.com>
From: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Message-ID: <ee62e419-6dd2-4cbd-c84a-d73b0cce2f2c@linux.intel.com>
Date: Mon, 12 Sep 2016 14:00:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ibiZG3SkW0TZywn8Qovo3hpxBqs4wCfw1DFEbbE=1-Mg@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Gleb Natapov <gleb@kernel.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 09/09/2016 11:40 PM, Dan Williams wrote:
> On Fri, Sep 9, 2016 at 1:55 AM, Xiao Guangrong
> <guangrong.xiao@linux.intel.com> wrote:
> [..]
>>>
>>> Whether a persistent memory mapping requires an msync/fsync is a
>>> filesystem specific question.  This mincore proposal is separate from
>>> that.  Consider device-DAX for volatile memory or mincore() called on
>>> an anonymous memory range.  In those cases persistence and filesystem
>>> metadata are not in the picture, but it would still be useful for
>>> userspace to know "is there page cache backing this mapping?" or "what
>>> is the TLB geometry of this mapping?".
>>
>>
>> I got a question about msync/fsync which is beyond the topic of this thread
>> :)
>>
>> Whether msync/fsync can make data persistent depends on ADR feature on
>> memory
>> controller, if it exists everything works well, otherwise, we need to have
>> another
>> interface that is why 'Flush hint table' in ACPI comes in. 'Flush hint
>> table' is
>> particularly useful for nvdimm virtualization if we use normal memory to
>> emulate
>> nvdimm with data persistent characteristic (the data will be flushed to a
>> persistent storage, e.g, disk).
>>
>> Does current PMEM programming model fully supports 'Flush hint table'? Is
>> userspace allowed to use these addresses?
>
> If you publish flush hint addresses in the virtual NFIT the guest VM
> will write to them whenever a REQ_FLUSH or REQ_FUA request is sent to
> the virtual /dev/pmemX device.  Yes, seems straightforward to take a
> VM exit on those events and flush simulated pmem to persistent
> storage.
>

Thank you, Dan!

However REQ_FLUSH or REQ_FUA is handled in kernel space, okay, after following
up the discussion in this thread, i understood that currently filesystems have
not supported the case that usespace itself make data be persistent without
kernel's involvement. So that works.

Hmm, Does device-DAX support this case (make data be persistent without
msync/fsync)? I guess no, but just want to confirm it. :)


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
