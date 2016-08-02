Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D24CE1A1E51
 for <linux-nvdimm@lists.01.org>; Mon,  1 Aug 2016 17:16:53 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id l65so215034085oib.1
 for <linux-nvdimm@lists.01.org>; Mon, 01 Aug 2016 17:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4bd310fe-68c2-4a2d-86ec-cf4b34ff179c@hpe.com>
References: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
 <a3a59c82-ccbb-75ac-ee21-12c58ac51d39@hpe.com>
 <20160728094518.cqtaavikkrzqnf7k@c203.arch.suse.de>
 <92aa03b2-326d-a932-90df-36cae9b11ecc@hpe.com>
 <20160729115538.hkhywboarkmzb6ti@c203.arch.suse.de>
 <de71bb80-d0be-d5b7-39ed-dd24f53cc2e9@hpe.com>
 <CAPcyv4ipJvm4jtH9ZhvDuPW00-ing-uutN0kLc9JNN1aXgsFJQ@mail.gmail.com>
 <4bd310fe-68c2-4a2d-86ec-cf4b34ff179c@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Aug 2016 17:16:52 -0700
Message-ID: <CAPcyv4jnukf+x1NUuj3qJ8En35VRD63y_gxgZOtL_2ki=vpaCQ@mail.gmail.com>
Subject: Re: HPE SMART data retreival
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 1, 2016 at 3:51 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> I don't think having multiple modules means there have to be multiple
> management models, it just allows for multiple management implementations.
> ACPI is all about abstracting differences.

ACPI is also about vendors talking to each other to minimize divergence.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
