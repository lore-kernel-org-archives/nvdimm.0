Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8795321A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 05:49:54 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] libnvdimm: fix btt vs clear poison locking
References: <149195214773.14530.8851419580700446789.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Wed, 12 Apr 2017 08:49:52 -0400
In-Reply-To: <149195214773.14530.8851419580700446789.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Tue, 11 Apr 2017 16:10:58 -0700")
Message-ID: <x49y3v56b9r.fsf@segfault.boston.devel.redhat.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> As a minimal fix, disable error clearing when the BTT is enabled for the
> namespace. For the final fix a larger rework of the poison list locking
> is needed.

I think "fix" is a strong word for this patch.  ;-)  Looks fine, though.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
