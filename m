Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11A05220F3C25
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 22:32:19 -0800 (PST)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/3] libnvdimm: Add a device-tree interface
In-Reply-To: <20171116142840.er7st25ll3o6jr7s@rob-hp-laptop>
References: <20171115175131.23631-1-oohall@gmail.com>
 <20171115175131.23631-2-oohall@gmail.com>
 <20171116142840.er7st25ll3o6jr7s@rob-hp-laptop>
Date: Fri, 24 Nov 2017 17:36:33 +1100
Message-ID: <87ine018um.fsf@concordia.ellerman.id.au>
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
To: Rob Herring <robh@kernel.org>, Oliver O'Halloran <oohall@gmail.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Rob Herring <robh@kernel.org> writes:
> On Thu, Nov 16, 2017 at 04:51:30AM +1100, Oliver O'Halloran wrote:
...
>> diff --git a/drivers/nvdimm/of_nvdimm.c b/drivers/nvdimm/of_nvdimm.c
>> new file mode 100644
>> index 000000000000..765cbbae8bcb
>> --- /dev/null
>> +++ b/drivers/nvdimm/of_nvdimm.c
>> @@ -0,0 +1,202 @@
>> +/*
>> + * Copyright 2017, IBM Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, you can access it online at
>> + * http://www.gnu.org/licenses/gpl-2.0.html.
>
> This can be SPDX tag.

Specifically:

// SPDX-License-Identifier: GPL-2.0+
/*
 * Copyright 2017, IBM Corporation
 */

...

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
