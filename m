Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24F5E21A07A80
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 15:42:22 -0800 (PST)
Received: by mail-pg1-f193.google.com with SMTP id z17-v6so25424pgv.3
 for <linux-nvdimm@lists.01.org>; Thu, 08 Nov 2018 15:42:22 -0800 (PST)
Message-ID: <1541720539.196084.236.camel@acm.org>
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order
 of operations for deferred probe and remove
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 08 Nov 2018 15:42:19 -0800
In-Reply-To: <499e4358e72fca510fa6fcfb76ea3ac3792db08f.camel@perches.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
 <1541548114.196084.195.camel@acm.org>
 <499e4358e72fca510fa6fcfb76ea3ac3792db08f.camel@perches.com>
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
To: Joe Perches <joe@perches.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-11-06 at 17:34 -0800, Joe Perches wrote:
> On Tue, 2018-11-06 at 15:48 -0800, Bart Van Assche wrote:
> > On Mon, 2018-11-05 at 13:12 -0800, Alexander Duyck wrote:
> > > One change I made in addition is I replaced the use of "bool X:1" to define
> > > the bitfield to a "u8 X:1" setup in order to resolve some checkpatch
> > > warnings.
> > 
> > Please use "bool X:1" instead of "u8 X:1". I think it was a bad idea to make
> > checkpatch complain about "bool X:1" since "bool X:1" should only be avoided
> > in structures for which alignment must be architecture-independent. For struct
> > device it is fine if member alignment differs per architecture. Additionally,
> > changing "bool X:1" into "u8 X:1" will reduce performance on architectures that
> > cannot do byte addressing.
> 
> I generally agree.  But the checkpatch warning _could_
> be useful in those cases where alignment should be
> architecture-independent.
> 
> Any suggestion on how to improve the message?

It would be great if a heuristic could be developed that recognizes structs
for which the data layout must be architecture independent. If such a
heuristic could be developed it could be used to only display warn about
"bool X:n" for such structures.

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
