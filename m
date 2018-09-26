Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com
 [IPv6:2607:f8b0:4864:20::32e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E1552194D3AE
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:28:24 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id q4-v6so423041otf.13
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <153799466529.71621.10728628542331983376.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153799466529.71621.10728628542331983376.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Sep 2018 14:28:12 -0700
Message-ID: <CAPcyv4hfsV6eiUOVXg7HwGr7GpMpv=9Tjg1wMVY_UNDtMat_mg@mail.gmail.com>
Subject: Re: [PATCH v10 00/12] Adding security support for nvdimm
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 26, 2018 at 1:47 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> The following series implements security support for nvdimm. Mostly adding
> new security DSM support from the Intel NVDIMM DSM spec v1.7, but also
> adding generic support libnvdimm for other vendors. The most important
> security features are unlocking locked nvdimms, and updating/setting security
> passphrase to nvdimms.
>
> v10:

Looks good to me, I'll get this soaking in -next. David please pipe up
if there are any concerns left unaddressed, but I think Dave covered
them all.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
