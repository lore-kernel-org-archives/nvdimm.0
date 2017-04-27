Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9436821A04804
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 12:43:43 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] libnvdimm, region: sysfs trigger for nvdimm_flush()
References: <149307780135.7155.11108531648914675756.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149315140303.23340.14688142799059150805.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49zif23nvl.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jQXRQVHnNMqJDrwSMM=1kJx_7sWifUN-u1yusVCZ0roQ@mail.gmail.com>
 <x49y3umufpm.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jOP6fhk4wXahdEWH2O_93LQe9yzrWYZatSXXDwEk5OBA@mail.gmail.com>
 <x49d1bxsngb.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4g1zbaNDttkzGv4NV9ZQXrObLqpPLMQW2wqoP_iTozrsQ@mail.gmail.com>
 <CAPcyv4hDmwSO8szjn+mqL6xpW2H92WsTDn=8qLtJi7Y8kduX5Q@mail.gmail.com>
Date: Thu, 27 Apr 2017 15:43:41 -0400
In-Reply-To: <CAPcyv4hDmwSO8szjn+mqL6xpW2H92WsTDn=8qLtJi7Y8kduX5Q@mail.gmail.com>
 (Dan Williams's message of "Thu, 27 Apr 2017 12:21:54 -0700")
Message-ID: <x491ssdprf6.fsf@segfault.boston.devel.redhat.com>
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> We also still seem to need a discovery mechanism as I've had questions
> about "how do I tell if my system supports deep flush?". That's where
> sysfs is much better than an ioctl. The need for deep flush discovery
> tips the scales, at least for me, to also do deep flush triggering
> through the same interface.

Return ENXIO or EOPNOTSUPP from the ioctl when it isn't supported?

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
