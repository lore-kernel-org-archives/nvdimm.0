Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EFCD021DF37BA
 for <linux-nvdimm@lists.01.org>; Sun,  6 Aug 2017 17:06:36 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AA896AC0143
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 09:08:47 +0900 (JST)
Date: Mon, 07 Aug 2017 09:08:25 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC/Patch 4/5] libndctl Make interfaces to use Translate SPA
In-Reply-To: <CAPcyv4i+vaOitbe5iEqvRG12XNhYiRU3O6_Kmn9v6vtN0Yrg=Q@mail.gmail.com>
References: <20170804181223.27CC.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4i+vaOitbe5iEqvRG12XNhYiRU3O6_Kmn9v6vtN0Yrg=Q@mail.gmail.com>
Message-Id: <20170807090822.F962.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Fri, Aug 4, 2017 at 2:12 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > ndctl:libndctl Make interfaces to use Translate SPA.
> 
> A process note, please separate kernel patches and ndctl patches into
> a different set. The expectation is that all the [PATCH 1/n] to [PATCH
> n/n] should apply to the same project.
> 
> I have typically been marking my ndctl patches with a prefix like
> [ndctl PATCH 1/n], where the kernel patches just say [PATCH].
> 
> >
> > This patch makes 3 new interfaces :
> >   - to ask bus has translate SPA feature.
> >   - to call translate SPA.
> >   - to find DIMM by SPA address.
> >
> >
> > Note) I'm not sure how many buffer should be prepared, because
> >       it depends on max # of mirroring way.
> >       This patch assume maxmum # is 4 way.
> 
> I think it is ok for now to just reserve space for 1-DIMM. When / if
> mirroring support materializes in the kernel you should then be able
> to detect how many DIMMs are in the mirror set. Since mirror support
> would require changes to the Namespace Label specification I think we
> have time to circle back and fix up ndctl for the multiple DIMM per
> Translate SPA request case.


I see. I'll reserve space for 1-DIMM.

> 
> Otherwise, the kernel will handle the case where the provided buffer
> is too small and return an error.
> 




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
