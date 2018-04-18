Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B84C022690AAB
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 07:31:28 -0700 (PDT)
Received: by mail-ot0-x235.google.com with SMTP id v64-v6so2119463otb.13
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 07:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180418063242.9221-1-qi.fuli@jp.fujitsu.com>
References: <20180418063242.9221-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Apr 2018 07:31:22 -0700
Message-ID: <CAPcyv4gb0JVRtW8QQy_TkJyZmpteGveOgzAPt66Otx0sftyrHw@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl, filter: refacor util_<obj>_filter() to support
 multiple space-seperated arguments
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 11:32 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch refactors util_<obj>_filter to support multiple space-seperated
> arguments. Currently, only one <object> can be filtered by <object>'s name
> in util_<obj>_filter(). As a result, when users want to moniotr multiple
> dimms, they have to run multiple monitor processes. This feature teachs the
> util_dimm_filter() that the "ident" argument maybe a space-seperatd string
> which includes multiple dimm_names. Therefore the monitor can filter
> multiple dimms in one process.
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Change log since v1:
>   - Removing OPT_STRING_LIST from parse-option

Looks good:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
