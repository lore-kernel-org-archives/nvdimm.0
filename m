Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE9071A1FAD
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 08:48:12 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id w85so63600739oiw.0
 for <linux-nvdimm@lists.01.org>; Wed, 06 Apr 2016 08:48:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8ef3af4dcab49a391a649d059b615670@suse.de>
References: <20160406003703.6821.64797.stgit@dwillia2-desk3.jf.intel.com>
 <8ef3af4dcab49a391a649d059b615670@suse.de>
Date: Wed, 6 Apr 2016 08:48:12 -0700
Message-ID: <CAPcyv4gKxwiOqvd21LC1nxwaH5cr-A8x_T6XBNrN2fehEdRejg@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: add ndctl_dimm_get_{formats|formatN}
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 6, 2016 at 1:26 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On 2016-04-06 02:37, Dan Williams wrote:
>>
>> Add apis to return the alternative format interface codes that a given
>> dimm supports.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Thanks Johannes!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
