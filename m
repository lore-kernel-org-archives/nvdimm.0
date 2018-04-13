Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B664220E8CD8
 for <linux-nvdimm@lists.01.org>; Fri, 13 Apr 2018 15:03:52 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id 188-v6so9685214oih.8
 for <linux-nvdimm@lists.01.org>; Fri, 13 Apr 2018 15:03:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gzJ4gcWgwOOmER1z7zsWR+X2zao-tMh8TjN9tx2kg_0g@mail.gmail.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246901060.36038.4487158506830998280.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404094656.dssixqvvdcp5jff2@quack2.suse.cz>
 <CAPcyv4joRA=BrurYZ1kzXpMG=jnXik9+LdLqH9961jM5VnmU7w@mail.gmail.com>
 <20180409164944.6u7i4wgbp6yihvin@quack2.suse.cz>
 <CAPcyv4gzJ4gcWgwOOmER1z7zsWR+X2zao-tMh8TjN9tx2kg_0g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Apr 2018 15:03:51 -0700
Message-ID: <CAPcyv4h3RPdohsPyiB=GxE8iQCjRRen=knDd=Em5BMy1MYpRvA@mail.gmail.com>
Subject: Re: [PATCH v8 15/18] mm, fs,
 dax: handle layout changes to pinned dax mappings
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
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Josh Triplett <josh.triplett@intel.com>, Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 9, 2018 at 9:51 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Apr 9, 2018 at 9:49 AM, Jan Kara <jack@suse.cz> wrote:
>> On Sat 07-04-18 12:38:24, Dan Williams wrote:
> [..]
>>> I wonder if this can be trivially solved by using srcu. I.e. we don't
>>> need to wait for a global quiescent state, just a
>>> get_user_pages_fast() quiescent state. ...or is that an abuse of the
>>> srcu api?
>>
>> Well, I'd rather use the percpu rwsemaphore (linux/percpu-rwsem.h) than
>> SRCU. It is a more-or-less standard locking mechanism rather than relying
>> on implementation properties of SRCU which is a data structure protection
>> method. And the overhead of percpu rwsemaphore for your use case should be
>> about the same as that of SRCU.
>
> I was just about to ask that. Yes, it seems they would share similar
> properties and it would be better to use the explicit implementation
> rather than a side effect of srcu.

...unfortunately:

 BUG: sleeping function called from invalid context at
./include/linux/percpu-rwsem.h:34
 [..]
 Call Trace:
  dump_stack+0x85/0xcb
  ___might_sleep+0x15b/0x240
  dax_layout_lock+0x18/0x80
  get_user_pages_fast+0xf8/0x140

...and thinking about it more srcu is a better fit. We don't need the
100% exclusion provided by an rwsem we only need the guarantee that
all cpus that might have been running get_user_pages_fast() have
finished it at least once.

In my tests synchronize_srcu is a bit slower than unpatched for the
trivial 100 truncate test, but certainly not the 200x latency you were
seeing with syncrhonize_rcu.

Elapsed time:
0.006149178 unpatched
0.009426360 srcu
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
