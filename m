Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EECA2113A0E0
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 15:12:39 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id u74-v6so6691762oia.11
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 15:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <153817140052.17152.8594371908103118425.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153817140052.17152.8594371908103118425.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Sep 2018 15:12:27 -0700
Message-ID: <CAPcyv4hUk9v6+j811QYmOJvJ6MVXH-bF=ikXdMu8EpF9ppk=Qw@mail.gmail.com>
Subject: Re: [PATCH v11 00/12] Adding security support for nvdimm
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

On Fri, Sep 28, 2018 at 2:58 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> The following series implements security support for nvdimm. Mostly adding
> new security DSM support from the Intel NVDIMM DSM spec v1.7, but also
> adding generic support libnvdimm for other vendors. The most important
> security features are unlocking locked nvdimms, and updating/setting security
> passphrase to nvdimms.
>
> v11:
> - Dropped keyring usage. (David)
> - Fixed up scanf handling. (David)
> - Removed callout info for request_key(). (David)
> - Included Dan's patches and folded in some changes from Dan. (Dan)
> - Made security_show a weak function to allow test override. (Dan)

Looks good.

> Dan Williams (2):
>       libnvdimm: Drop nvdimm_bus from security_ops interface
>       acpi, nfit: Move acpi_nfit_get_security_ops() to generic location

I'll fold these into the other patches, no need to commit the cleanups
separately at this point.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
