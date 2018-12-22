Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14EC3211963EA
 for <linux-nvdimm@lists.01.org>; Sat, 22 Dec 2018 11:04:49 -0800 (PST)
Date: Sat, 22 Dec 2018 14:04:47 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: Re: FAILED: patch "[PATCH] dax: Don't access a freed inode" failed
 to apply to 4.19-stable tree
Message-ID: <20181222190447.GO86645@sasha-vm>
References: <1544536809243247@kroah.com>
 <20181211152349.GE6830@bombadil.infradead.org>
 <20181214071344.GC31355@kroah.com>
 <CAPcyv4hHnR95zAcxU9RqZvbaP1BB0_NUFsRuQcDY9zkKKQV_Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hHnR95zAcxU9RqZvbaP1BB0_NUFsRuQcDY9zkKKQV_Ug@mail.gmail.com>
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
Cc: Greg KH <gregkh@linuxfoundation.org>, Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 21, 2018 at 12:31:02PM -0800, Dan Williams wrote:
>On Thu, Dec 13, 2018 at 11:14 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Tue, Dec 11, 2018 at 07:23:49AM -0800, Matthew Wilcox wrote:
>> > On Tue, Dec 11, 2018 at 03:00:09PM +0100, gregkh@linuxfoundation.org wrote:
>> > >
>> > > The patch below does not apply to the 4.19-stable tree.
>> > > If someone wants it applied there, or to any other stable or longterm
>> > > tree, then please email the backport, including the original git commit
>> > > id to <stable@vger.kernel.org>.
>> >
>> > I have only compile-tested this backport.  Dan, do you want to run it
>> > through some tests before Greg applies it?
>>
>> Thanks for the backport, I'll wait to hear from Dan before queueing this
>> up.
>
>Tested-by: Dan Williams <dan.j.williams@intel.com>
>
>However, on the upstream version of this fix Linus pointed out an
>additional fixup. Once that goes upstream [1] I'll circle back to
>provide a fixed up version of this backport to keep -stable and
>mainline more aligned.
>
>[1]: https://marc.info/?l=linux-fsdevel&m=154542184202064&w=2

Okay, I guess it makes sense to wait for the fixup before we pull this
backport in?

--
Thanks,
Sasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
