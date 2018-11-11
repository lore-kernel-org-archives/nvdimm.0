Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6AE6F2117CE94
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 14:18:05 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id p144-v6so5674728oic.12
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 14:18:05 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041079.12967.13132220574997822111.stgit@ahduyck-desk1.jf.intel.com>
 <20181111193208.GB8332@kroah.com>
 <CAPcyv4hofCTYMNN=Ow=o4RRuUPM=GLWajNAT9q6WWkuV47te_w@mail.gmail.com>
 <20181111203541.GB16871@kroah.com>
In-Reply-To: <20181111203541.GB16871@kroah.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 11 Nov 2018 14:17:53 -0800
Message-ID: <CAPcyv4hw0YS3XgdsDNL6MGqZs1bMhFxxQZC1UJT3gzpD4Ym7QA@mail.gmail.com>
Subject: Re: [driver-core PATCH v6 2/9] async: Add support for queueing on
 specific NUMA node
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
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Nov 11, 2018 at 12:35 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Nov 11, 2018 at 11:53:20AM -0800, Dan Williams wrote:
> > On Sun, Nov 11, 2018 at 11:32 AM Greg KH <gregkh@linuxfoundation.org> wrote:
[..]
> This would be a great time for some other people to do that review :)

Message received, I'll block some time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
