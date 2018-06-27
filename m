Return-Path: <pmem+bncBDENZKVKQYIBBAVSZ3MQKGQEOGTC2JQ@googlegroups.com>
Sender: pmem@googlegroups.com
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hzfy0pvniMz4-PcaAXo6kFC=n4hyPzd=0v-JxCsUhMhQ@mail.gmail.com>
References: <alpine.LRH.2.02.1806180846300.22626@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4i_xqo1AgF7znUYi+Eo_obTBYA5vMv7=Q0VP755Kmm9bg@mail.gmail.com>
 <CACTTzNbu5FNXiyDeSBgTZCE7x=aNKQWvMLnhy5rkE51JJV9Rzg@mail.gmail.com> <CAPcyv4hzfy0pvniMz4-PcaAXo6kFC=n4hyPzd=0v-JxCsUhMhQ@mail.gmail.com>
From: Yigal Korman <yigal@plexistor.com>
Date: Wed, 27 Jun 2018 17:02:20 +0300
Message-ID: <CACTTzNZOK8cYZBcSjShFKYCoaW33cFtCZP7bN1CmQg9ZXsVf2w@mail.gmail.com>
Subject: Re: [PATCH] x86: optimize memcpy_flushcache
Content-Type: text/plain; charset="UTF-8"
List-Post: <https://groups.google.com/group/pmem/post>, <mailto:pmem@googlegroups.com>
List-Help: <https://groups.google.com/support/>, <mailto:pmem+help@googlegroups.com>
List-Archive: <https://groups.google.com/group/pmem
List-Subscribe: <https://groups.google.com/group/pmem/subscribe>, <mailto:pmem+subscribe@googlegroups.com>
List-Unsubscribe: <mailto:googlegroups-manage+41775949424+unsubscribe@googlegroups.com>,
 <https://groups.google.com/group/pmem/subscribe>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Ingo Molnar <mingo@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, pmem <pmem@googlegroups.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 27, 2018 at 4:03 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Jun 27, 2018 at 4:23 AM, Yigal Korman <yigal@plexistor.com> wrote:
>> Hi,
>> I'm a bit late on this but I have a question about the original patch -
>> I thought that in order for movnt (movntil, movntiq) to push the data
>> into the persistency domain (ADR),
>> one must work with length that is multiple of cacheline size,
>> otherwise the write-combine buffers remain partially
>> filled and you need to commit them with a fence (sfence) - which ruins
>> the whole performance gain you got here.
>> Am I wrong, are the write-combine buffers are part of the ADR domain
>> or something?
>
> The intent is to allow a batch of memcpy_flushcache() calls followed
> by a single sfence. Specifying a multiple of a cacheline size does not
> necessarily help as sfence is still needed to make sure that the movnt
> result has reached the ADR-safe domain.

Oh, right, I see that dm-writecache calls writecache_commit_flushed
which in turn calls wmb().
I keep confusing *_nocache (i.e. copy_user_nocache) that includes
sfence and *_flushcache (i.e. memcpy_flushcache) that doesn't.
Thanks for the clear up.

-- 
You received this message because you are subscribed to the Google Groups "pmem" group.
To unsubscribe from this group and stop receiving emails from it, send an email to pmem+unsubscribe@googlegroups.com.
To post to this group, send email to pmem@googlegroups.com.
To view this discussion on the web visit https://groups.google.com/d/msgid/pmem/CACTTzNZOK8cYZBcSjShFKYCoaW33cFtCZP7bN1CmQg9ZXsVf2w%40mail.gmail.com.
For more options, visit https://groups.google.com/d/optout.
