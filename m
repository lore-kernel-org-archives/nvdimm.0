Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3C8920D7B90B
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:49:06 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id r203so45659054oib.3
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:49:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49y3v56b9r.fsf@segfault.boston.devel.redhat.com>
References: <149195214773.14530.8851419580700446789.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49y3v56b9r.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Apr 2017 13:49:05 -0700
Message-ID: <CAPcyv4ie1DL-yBshzkKzDydRDPQNM0yMDca-mABJTkJTXmExqw@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm: fix btt vs clear poison locking
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 5:49 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> As a minimal fix, disable error clearing when the BTT is enabled for the
>> namespace. For the final fix a larger rework of the poison list locking
>> is needed.
>
> I think "fix" is a strong word for this patch.  ;-)  Looks fine, though.

Heh, true. I'll rename it to "band aid" since the true "fix" is coming in 4.12.

> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
