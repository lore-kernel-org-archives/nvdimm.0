Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com
 [IPv6:2607:f8b0:4864:20::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 51B86210F4732
 for <linux-nvdimm@lists.01.org>; Fri, 21 Dec 2018 10:52:02 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m6so5561749oig.11
 for <linux-nvdimm@lists.01.org>; Fri, 21 Dec 2018 10:52:02 -0800 (PST)
MIME-Version: 1.0
References: <20181221193244.3a6ed685@canb.auug.org.au>
 <8ae0ad4e-0c5c-a3dc-51b4-1616f459e45b@infradead.org>
In-Reply-To: <8ae0ad4e-0c5c-a3dc-51b4-1616f459e45b@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Dec 2018 10:51:49 -0800
Message-ID: <CAPcyv4ic3Sf+KGcL3tDUx73GVY_gXmf4WPCxfA63jT6bW3LAEA@mail.gmail.com>
Subject: Re: linux-next: Tree for Dec 21 (nvdimm/security.o)
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
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 21, 2018 at 10:44 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 12/21/18 12:32 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > News: there will be no linux-next release until Jan 2.  Have a good break.
> >
> > Changes since 20181220:
> >
>
> on x86_64:
>
> ld: drivers/nvdimm/security.o: in function `nvdimm_request_key':
> security.c:(.text+0xbe): undefined reference to `key_type_encrypted'
> ld: drivers/nvdimm/security.o: in function `nvdimm_lookup_user_key.isra.1':
> security.c:(.text+0x1ea): undefined reference to `key_type_encrypted'
>
>
> Full randconfig file is attached.

Could you send me that randconfig, offlist is fine.

It seems the "depends on ENCRYPTED_KEYS" I added is not sufficient.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
