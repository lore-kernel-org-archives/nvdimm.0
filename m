Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x234.google.com (mail-yb0-x234.google.com
 [IPv6:2607:f8b0:4002:c09::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60C3B21D147B4
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jul 2017 00:34:40 -0700 (PDT)
Received: by mail-yb0-x234.google.com with SMTP id p207so35315605yba.2
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jul 2017 00:36:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOSf1CF=4E28H4Fu5Pmwb-iCVio5pM_pFoBy+gvkcSsNQkpeEA@mail.gmail.com>
References: <20170627102851.15484-1-oohall@gmail.com>
 <CAPcyv4g-vgaAZu9DWXfOcwH5p_ZJBwiMJFZ43rKWuJB2L-W7VQ@mail.gmail.com>
 <CAOSf1CF=4E28H4Fu5Pmwb-iCVio5pM_pFoBy+gvkcSsNQkpeEA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Jul 2017 00:36:24 -0700
Message-ID: <CAPcyv4j85boeJwCy0vt0fY_E30g7ywtxPG9OH+z0XCsBdOgKFw@mail.gmail.com>
Subject: Re: [RFC 1/4] libnvdimm: add to_{nvdimm,nd_region}_dev()
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
To: Oliver <oohall@gmail.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 10, 2017 at 9:38 PM, Oliver <oohall@gmail.com> wrote:
> On Tue, Jul 11, 2017 at 9:53 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Tue, Jun 27, 2017 at 3:28 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>>> struct device contains the ->of_node pointer so that devices can be
>>> assoicated with the device-tree node that created them on DT platforms.
>>> libnvdimm hides the struct device for regions and nvdimm devices inside
>>> of an opaque structure so this patch adds accessors for each to allow
>>> the of_nvdimm driver to set the of_node pointer.
>>
>> I'd rather go the other way and pass in the of_node to the bus and
>> dimm registration routines. It's a generic property of the device so
>> we should handle it like other generic device properties that get set
>> at initialization time like 'attr_groups' in nvdimm_bus_descriptor, or
>> a new parameter to nvdimm_create().
>
> Sure. I just figured it would be preferable to keep firmware specific
> details inside the firmware driver rather than adding #ifdef CONFIG_OF
> around the place. Do you have any objections to making nvdimm_create()
> take a descriptor structure rather than adding a parameter?

I don't see why we need "#ifdef CONFIG_OF". It's just a "struct
of_node *" pointer that can be forward declared as "struct of_node;"
we don't need the full definition.

Yes, I'm fine with converting nvdimm_create() to a take a descriptor,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
