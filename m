Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A5852267F0F9
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 19:15:20 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id B233DAC01B6
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 11:15:12 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
Date: Tue, 10 Apr 2018 02:15:10 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222764CEF8@g01jpexmbkw01>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01>
 <CAPcyv4jGnJ7geYUsQxjnSiHnRwCOWx8HOYVcx+Bom7AfRYLsyA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764C387@g01jpexmbkw01>
 <CAPcyv4j5gDKMhCN02PQkf1JUvzUSOYTJWZf854y0p3emKvV5DA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764CC51@g01jpexmbkw01>
 <CAPcyv4iYWC3iY+u91PGOQ3aJoJBUbVM--KjtNCA834PTAE4E6Q@mail.gmail.com>
In-Reply-To: <CAPcyv4iYWC3iY+u91PGOQ3aJoJBUbVM--KjtNCA834PTAE4E6Q@mail.gmail.com>
Content-Language: ja-JP
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> >
> > Thank you very much.
> >
> > I think the "logfile=<logfile path>" is also needed in the configuration file.
> >
> > One more question is that do you think it is necessary for ndctl list to support "one
> option multiple arguments"?
> > Currently, only "one option one argument" is allowed in ndctl list like "ndctl list
> --dimm nmem1 --bus ndbus1".
> > Due to monitor should support "one option multiple arguments" like
> > "ndctl monitor --dimm nmem1,nmem2", I am thinking modify the "strut
> util_filter_params" in util/filter.h, change the "const char *bus" to "char **buses"
> > or "link_list bus" and refactor the util_filter_walk in util/filter.h, then ndctl list also
> can support "ndctl list --dimm nmem1,nmem2".
> 
> That would be a welcome feature. Given that we already support the "all" keyword to
> match multiple objects in a filter it should be straightforward to support lists of
> objects.
> 
> The only concern is syntax. I think since the label commands "init-labels, read-labels,
> write-labels" takes a space separated list of objects I think we should do the same
> specifying multiple object names to the filter.
> 
> I.e. a request to list multiple specific dimms would be:
> 
>     ndctl list --dimm="nmem1 nmem2 nmem3"
> 
> ...space separation instead of comma allows you to rewrite that as:
> 
>     ndctl list --dimm="$(echo nmem{1,2,3)"

Ok, I see.
I will make a patch to refactor the util_filter_walk() and ndctl list.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
