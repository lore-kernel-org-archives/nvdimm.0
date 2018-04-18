Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4BDD222690AC9
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 09:06:27 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2] ndctl, filter: refacor util_<obj>_filter() to
 support multiple space-seperated arguments
Date: Wed, 18 Apr 2018 16:06:25 +0000
Message-ID: <1524067583.6010.7.camel@intel.com>
References: <20180418063242.9221-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4gb0JVRtW8QQy_TkJyZmpteGveOgzAPt66Otx0sftyrHw@mail.gmail.com>
In-Reply-To: <CAPcyv4gb0JVRtW8QQy_TkJyZmpteGveOgzAPt66Otx0sftyrHw@mail.gmail.com>
Content-Language: en-US
Content-ID: <8AB54B72C8CB0D4DAD6135E3252CBB69@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-04-18 at 07:31 -0700, Dan Williams wrote:
> On Tue, Apr 17, 2018 at 11:32 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> > This patch refactors util_<obj>_filter to support multiple space-
> > seperated
> > arguments. Currently, only one <object> can be filtered by <object>'s
> > name
> > in util_<obj>_filter(). As a result, when users want to moniotr
> > multiple
> > dimms, they have to run multiple monitor processes. This feature teachs
> > the
> > util_dimm_filter() that the "ident" argument maybe a space-seperatd
> > string
> > which includes multiple dimm_names. Therefore the monitor can filter
> > multiple dimms in one process.
> > 
> > Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I'll fix up the tags like so:

Based-on-a-patch-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>


Thanks,
	-Vishal

> > 
> > Change log since v1:
> >   - Removing OPT_STRING_LIST from parse-option
> 
> Looks good:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
