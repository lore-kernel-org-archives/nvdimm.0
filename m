Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C8FD321B02845
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:54:55 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id i12-v6so65281534oik.2
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:54:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153142855815.27297.740336926832022321.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
 <153142855815.27297.740336926832022321.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 16:54:54 -0700
Message-ID: <CAPcyv4hFBir+xwj-2czQD0ZSbWcQEGVbg_AGaYt7-v8Q_aLP3w@mail.gmail.com>
Subject: Re: [PATCH v4 09/11] nfit_test: add context to dimm_dev for nfit_test
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
> In order to access the nfit_test context via sideband sysfs knobs, the
> dimm_dev needs to be more than struct device in order to point back to
> struct nfit_test. Wrapping the original struct device with a struct
> nfit_dimm_dev and saving the nfit_test as private driver data. Also
> changing the nfit_mem to be a member of struct nfit_dimm_dev instead of
> saving as private driver data of that device. This is in preparation for
> adding security DSM support and allowing the locking of DIMMs for testing
> via sideband.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/nvdimm/test/nfit.c |   41 +++++++++++++++++++++++++-------------
>  1 file changed, 27 insertions(+), 14 deletions(-)

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
