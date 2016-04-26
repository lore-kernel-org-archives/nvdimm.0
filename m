Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B0311A1E58
 for <linux-nvdimm@lists.01.org>; Tue, 26 Apr 2016 11:10:52 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id x19so23850413oix.2
 for <linux-nvdimm@lists.01.org>; Tue, 26 Apr 2016 11:10:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <146161381575.21779.8108705781017518591.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146161381575.21779.8108705781017518591.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Tue, 26 Apr 2016 11:10:51 -0700
Message-ID: <CAPcyv4hRs+HYv=9BboYo-EkiuTvfNOWnqfO0YW6JwXKsQXHJ2w@mail.gmail.com>
Subject: Re: [ndctl PATCH 5/7] ndctl: fix to_dsm_index() static analysis
 warning
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 25, 2016 at 12:50 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Static analysis tools don't like the fact that we do multiple
> overwriting assignments to a variable.  Use IS_ENABLED() to clean this
> up.

Whoops, I changed this patch to use static const lowercase(command
name) intead of IS_ENABLED().  Here's the updated changelog:

Static analysis tools don't like the fact that we do multiple
overwriting assignments to a variable.  Use aliased always defined
values that to_dsm_index() can check against zero to determine if the
command is supported.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
