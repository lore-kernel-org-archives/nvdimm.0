Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x243.google.com (mail-ua0-x243.google.com
 [IPv6:2607:f8b0:400c:c08::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 355362265A8DE
 for <linux-nvdimm@lists.01.org>; Sat,  7 Apr 2018 01:08:40 -0700 (PDT)
Received: by mail-ua0-x243.google.com with SMTP id q26so2121298uab.0
 for <linux-nvdimm@lists.01.org>; Sat, 07 Apr 2018 01:08:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hRut3MjihCStXkO6QGXYQf6gmoPPmv_=9K-Z8qoVLL0Q@mail.gmail.com>
References: <20180406052116.31483-1-oohall@gmail.com>
 <CAPcyv4hRut3MjihCStXkO6QGXYQf6gmoPPmv_=9K-Z8qoVLL0Q@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Date: Sat, 7 Apr 2018 18:08:39 +1000
Message-ID: <CAKTCnzmuqTZWVXdUfMLRQMHW3MK8qtKbTXxBy9Lt32h4ET237A@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] libnvdimm: Add of_node to region and bus
 descriptors
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
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Apr 7, 2018 at 4:28 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Apr 5, 2018 at 10:21 PM, Oliver O'Halloran <oohall@gmail.com> wrote:
>> We want to be able to cross reference the region and bus devices
>> with the device tree node that they were spawned from. libNVDIMM
>> handles creating the actual devices for these internally, so we
>> need to pass in a pointer to the relevant node in the descriptor.
>>
>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>
> These look good to me. I'll get them applied today and let them soak
> over the weekend for a pull request on Monday.
>
> If anyone wants to add Acks or Reviews I can append them to the merge
> tag. If there are any NAKs please speak up now, but as far as I know
> there are no pending device-tree design concerns.

Hi, Dan

I can ack Oliver's work, will do so in each patch

Overall

Acked-by: Balbir Singh <bsingharora@gmail.com>

Balbir Singh
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
