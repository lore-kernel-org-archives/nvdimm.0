Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 134372097F55F
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:55:50 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id y207-v6so65254947oie.13
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:55:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153142856380.27297.8637660094319867960.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
 <153142856380.27297.8637660094319867960.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 16:55:48 -0700
Message-ID: <CAPcyv4jzZ9Gi=MZxmYD08vpJYKKrwBHWwZQqa=VJfzQfSksH2Q@mail.gmail.com>
Subject: Re: [PATCH v4 10/11] nfit_test: add test support for Intel nvdimm
 security DSMs
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
Cc: David Howells <dhowells@redhat.com>, "Schofield, Alison  <alison.schofield@intel.com>, keyrings@vger.kernel.org, Kees Cook" <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 12, 2018 at 1:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Add nfit_test support for DSM functions "Get Security State",
> "Set Passphrase", "Disable Passphrase", "Unlock Unit", "Freeze Lock",
> and "Secure Erase" for the fake DIMMs.
>
> Also adding a sysfs knob in order to put the DIMMs in "locked" state. The
> order of testing DIMM unlocking would be.
> 1a. Set Passphrase to DIMM X.
> 1b. Disable DIMM X.
> 2. Write to
> /sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimmX/lock_dimm
> 3. Renable DIMM X
> 4. Check DIMM X state via sysfs "security" attribute for nmemX.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/nvdimm/Kbuild      |    1
>  tools/testing/nvdimm/test/nfit.c |  186 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 187 insertions(+)

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
