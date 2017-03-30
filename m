Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 530912063E060
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 10:12:24 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id f193so37552927oib.2
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 10:12:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <530a437d-e6af-a107-5c1a-2fc3ce6710a9@hpe.com>
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4i+q6iL9+fEUgL23Mb33Y7toCpXpeqh0rUgD+tcH3a2hg@mail.gmail.com>
 <x49r31fsunx.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jsJZih6t_hQ2Y3T8n0cGh79Kjf98WHfK0xoTVuifrTUQ@mail.gmail.com>
 <58DD2D73.9040902@hpe.com>
 <CAPcyv4j_bSSjP_a+DxPqnRcPT5WiaiiRQLUy0L5sUeSEXfrbEg@mail.gmail.com>
 <530a437d-e6af-a107-5c1a-2fc3ce6710a9@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Mar 2017 10:12:23 -0700
Message-ID: <CAPcyv4iHJ62Q5bV5UtJSrxfEjN0bGCnV+jYWfuYGrFUnSFQxgg@mail.gmail.com>
Subject: Re: [PATCH] test: add fio test for device-dax
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

On Thu, Mar 30, 2017 at 10:06 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 3/30/2017 12:56 PM, Dan Williams wrote:
[..]
>> Patches welcome :).
>
>
> You won't like my patch for that because I agree with Jeff. :-)
>
> Right now I'm more interested in seeing if I can modify the tests to not
> require nfit_test.  I've only looked at btt-check.sh but so far, it doesn't
> look that hard.

The point of nfit_test is that you can run them with worrying about
risks to real data. So I don't want to see patches moving existing
nfit_test tests to something else.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
