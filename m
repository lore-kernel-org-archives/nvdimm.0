Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6917B202E5CD0
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 15:58:16 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id f66so16541554oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 16:01:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013001004.14963-2-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
 <20171013001004.14963-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 16:01:47 -0700
Message-ID: <CAPcyv4jHPfEs51cJkCx1SGU=XL=BHYAQ0wBZ-SQgtn=14cj8Rw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 1/6] libndctl: add APIs to get scrub count and to
 wait for a scrub
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 5:09 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The kernel uses sysfs to notify userspace of the number of completed
> Address Range Scrubs, as well as any ongoing scrubs. Add libndctl
> helpers to get the scrub count, and to wait for an in-progress scrub to
> complete.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
