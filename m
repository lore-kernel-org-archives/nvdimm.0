Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x230.google.com (mail-ot0-x230.google.com
 [IPv6:2607:f8b0:4003:c0f::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F09222620E82
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 12:03:01 -0700 (PDT)
Received: by mail-ot0-x230.google.com with SMTP id f47-v6so2283589oth.2
 for <linux-nvdimm@lists.01.org>; Fri, 06 Apr 2018 12:03:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222764C387@g01jpexmbkw01>
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01>
 <CAPcyv4jGnJ7geYUsQxjnSiHnRwCOWx8HOYVcx+Bom7AfRYLsyA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764C387@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Apr 2018 12:02:59 -0700
Message-ID: <CAPcyv4j5gDKMhCN02PQkf1JUvzUSOYTJWZf854y0p3emKvV5DA@mail.gmail.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

bus="<bus filter option>"


On Thu, Apr 5, 2018 at 4:17 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
[..]
>> This seems to needlessly tie ndctl to systemd, it should be able to operate without
>> requiring systemd. I expect it would be straightforward to copy the configuration file
>> implementation from git.
>
> I have read the configuration file implementation of git, my understanding is that git daemon does not
> have any options used to override default configuration.
> I want to confirm if the configuration file is only used for ndctl monitor.
> If yes, I do not think copy the configuration file implementation from git is a good choice,
> because only getting keys and values from configuration file is needed for us and the structure of
> configuration file implementation in git is too complexity.
> I prefer to borrow from udev[1], because the implementation in udev is simpler and it seems ndctl also borrows a lot from udev.
>
> [1] https://git.kernel.org/pub/scm/linux/hotplug/udev.git/tree/src/libudev.c

Thank you for doing the due diligence on this investigation it is appreciated.

I think the simple udev approach is acceptable. Going back to the
proposed command line options of: --dimm-events, --namespace-events,
--region-events, --bus-events and device filter selectors (like the
ndctl list options) we can just have variables in the config file for
those, so:

dimm-events="<list of dimm events>"
namespace-events=="<list of namespace events>"
region-events=="<list of region events>"
bus-events="<list of bus events>"
dimm="<bus filter option>"
dimm="<dimm filter option>"
region="<region filter option>"
namespace="<namespace filter option>"

Thoughts?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
