Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C420F2264A1FE
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 07:48:24 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id u141-v6so19483089oif.1
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 07:48:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180404143713.t4lsufodbe7pr2jm@XZHOUW.usersys.redhat.com>
References: <20180404143713.t4lsufodbe7pr2jm@XZHOUW.usersys.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Apr 2018 07:48:23 -0700
Message-ID: <CAPcyv4iyzpSVKmV_dC2TyUkbX0J69bqzNT_eQGM9vMXqBac1qA@mail.gmail.com>
Subject: Re: Can't hit dax pmd fault on nvdimm in raw mode
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
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 4, 2018 at 7:37 AM, Xiong Zhou <xzhou@redhat.com> wrote:
> Hi,
>
> It works fine in memory mode. Both tested on latest Linus tree with xfs.
>
> Referring https://nvdimm.wiki.kernel.org/2mib_fs_dax
>
> Did I miss anything?

No, this behavior is by design. See commit ee82c9ed41e8 "dax: disable
pmd mappings". The short summary is that struct page is needed to
support get_user_pages() on dax pmd mappings, and raw mappings do not
provide struct page.

Details here: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ee82c9ed41e8
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
