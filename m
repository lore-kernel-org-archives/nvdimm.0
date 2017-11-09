Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D69C202E5E71
 for <linux-nvdimm@lists.01.org>; Thu,  9 Nov 2017 13:08:33 -0800 (PST)
Received: by mail-oi0-x236.google.com with SMTP id q4so5418802oic.7
 for <linux-nvdimm@lists.01.org>; Thu, 09 Nov 2017 13:12:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171109210856.11936-1-vishal.l.verma@intel.com>
References: <20171109210856.11936-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Nov 2017 13:12:34 -0800
Message-ID: <CAPcyv4gBy+UDFhxe8DnRaWQGd5c_1btwsm_ZQURgF4MRguF-zg@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] libndctl, nfit: Fix in/out sizes for error
 injection commands
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 9, 2017 at 1:08 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The input/output size bounds being set in the various nd_bus_cmd_new_*
> helpers for error injection commands were larger than they needed to be,
> and platforms could reject these. Fix the bounds to be exactly as the
> spec describes.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/nfit.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> v2: set the in/out sizes based explicitly on the sizes/offsets in the
> cmd structure so that their relationship becomes obvious (Dan).

Looks good, thanks for fixing that up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
