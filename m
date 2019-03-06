Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68FA8211D56B5
 for <linux-nvdimm@lists.01.org>; Tue,  5 Mar 2019 22:33:06 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id n71so9749346ota.10
 for <linux-nvdimm@lists.01.org>; Tue, 05 Mar 2019 22:33:06 -0800 (PST)
MIME-Version: 1.0
References: <20190130105927.31901-1-oohall@gmail.com>
In-Reply-To: <20190130105927.31901-1-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Mar 2019 22:32:53 -0800
Message-ID: <CAPcyv4iKk2_QS=+8z03c7cQ-r6nvZbwp0aM9jj+T2YaSHDHg=A@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] libndctl: Use the supported_alignment attribute
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 30, 2019 at 2:59 AM Oliver O'Halloran <oohall@gmail.com> wrote:
>
> Newer kernels provide the "supported_alignments" sysfs attribute that
> indicates what alignments can be used with a PFN or DAX namespace. This
> patch adds the plumbing inside of libndctl to allow users to query this
> information through using:
>         ndctl_{dax|pfn}_get_supported_alignment(), and
>         ndctl_{dax|pfn}_get_num_alignments()
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> v5: Fixed comment wording
>
> v4: Changed return code of ndctl_pfn_get_supported_alignment from -1 to
>     -1 to -EINVAL.
>
>     Reworded comment about why we default to 4K and 2M alignments when
>     the sysfs attribute is missing.
>
>     Shuffled around prototypes in ndctl.h.
>
>     80 char compliance fixes.
>
>     rebased onto pending branch
>
> v3: Changed the return type of the *_get_supported_alignment() functions
>     to unsigned long to match the existing *_get_alignment() functions.

After playing with this facility in the v64 release I think it needs a
redo for the following reasons:

* It's a bit too chatty and redundant even behind a "-v" because all
namespaces share the same attributes,

* this breaks the long standing, but admittedly not documented, style
guideline that all json values have an associated key, even if the key
is effectively just a generic index value. There are common methods to
enumerate the key space, but key-less arrays need to be handled
explicitly.

* It's the only field in the json that does not reflect the current
state of a device. For this reason I think it should be moved behind a
--capabilities flag and a named "capability" object as a child of a
region. This would also help with the redundant "supported" prefix.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
