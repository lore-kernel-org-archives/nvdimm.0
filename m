Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B33A321E49055
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 13:29:59 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id b8so840891oib.11
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 13:36:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152097246946.29587.17095835339672187253.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152097246946.29587.17095835339672187253.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Mar 2018 13:36:19 -0700
Message-ID: <CAPcyv4h+x8hOMq0Hbg1xkGRzrON0jJXQkAsbPLsgGFG9m_AhZw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, list: fix namespace json object parenting
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
To: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 13, 2018 at 1:21 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> When listing namespaces and regions a generic jplatform object is
> created to house the regions array. However, commit f8cc6fee4e4d "ndctl,
> list: refactor core topology walking into util_filter_walk()"
> inadvertently added namespaces to that jplatform. Namespaces should only
> be added to jplatform in the case when regions are not being listed.
> Otherwise we get duplicated output and a double-put assertion as seen
> below:

Ignore this patch, I see a different problem.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
