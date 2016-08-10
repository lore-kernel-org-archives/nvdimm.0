Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 270A31A1E2A
 for <linux-nvdimm@lists.01.org>; Tue,  9 Aug 2016 23:29:26 -0700 (PDT)
Received: by mail-wm0-x244.google.com with SMTP id q128so7530687wma.1
 for <linux-nvdimm@lists.01.org>; Tue, 09 Aug 2016 23:29:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160809152707.GA14291@linux.intel.com>
References: <20160808185747.21028-1-ross.zwisler@linux.intel.com>
 <CALYGNiMUsThwy3q_kdon3oszg8vpqaenWxx=h=ubcT9B_ZAbhw@mail.gmail.com>
 <20160809152707.GA14291@linux.intel.com>
From: Konstantin Khlebnikov <koct9i@gmail.com>
Date: Wed, 10 Aug 2016 09:29:23 +0300
Message-ID: <CALYGNiNwTXY2qQtx2nU9LjTiEYWwoHR63SnrkwUJpwgOLJPKSQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] radix-tree: 'slot' can be NULL in
 radix_tree_next_slot()
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 9, 2016 at 6:27 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Mon, Aug 08, 2016 at 10:21:39PM +0300, Konstantin Khlebnikov wrote:
> <>
>> NAK. This is fast path and it's already bloated.
>> I want to revert most changes here and rework "multiorder" entries.
>>
>> Here you can find almost ready patchset for that
>> https://github.com/koct9i/linux/commits/radix-tree
>
> Okay...are you okay with the second 2 patches in the series?  They stand
> alone, and I believe are both good to have.

They looks good.

If you're worried about complicated paths - I'll add comment for
*_next_slot() about that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
