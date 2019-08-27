Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com
 [IPv6:2607:f8b0:4864:20::331])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC3C620213F05
 for <linux-nvdimm@lists.01.org>; Mon, 26 Aug 2019 18:25:09 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id w4so17077955ote.11
 for <linux-nvdimm@lists.01.org>; Mon, 26 Aug 2019 18:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <1254901996.3735926.1564533684889.JavaMail.zimbra@redhat.com>
 <x498srsdhrs.fsf@segfault.boston.devel.redhat.com>
 <x49y2zfudej.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49y2zfudej.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Aug 2019 18:22:43 -0700
Message-ID: <CAPcyv4hu+ShtryhDOaKUOHpw2LrHcqwB69oT10uVS4aORaJ66A@mail.gmail.com>
Subject: Re: create devdax with "-a 1g" failed from 5.3.0-rc1
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Yi Zhang <yi.zhang@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 26, 2019 at 8:58 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan, we should probably fix this before 5.3 ships.  Do you have any
> concerns with the patch I attached?  If not, I'll submit a proper one.

I took a look. No concerns from me. Yeah, send a proper one and I'll
get it queued for v5.3.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
