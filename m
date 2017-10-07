Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A438021FC748C
 for <linux-nvdimm@lists.01.org>; Sat,  7 Oct 2017 08:51:45 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id p126so33840480oih.9
 for <linux-nvdimm@lists.01.org>; Sat, 07 Oct 2017 08:55:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006015405.29908-3-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
 <20171006015405.29908-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Oct 2017 08:55:09 -0700
Message-ID: <CAPcyv4hP+GuC7fsS3bibzCShH_k2g9SYKZ+h-zEW8=Y0fq1Eeg@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/8] ndctl,
 list: move the --human description to an include
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

On Thu, Oct 5, 2017 at 6:53 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> In preparation for inject-error, move the --human option description
> to a file that can be included. Reword the description improving
> the grammar, and making it more generic.
>
> The example in the list man page for --human was also missing a [verse]
> keyword, making the --human part of the example appear in a single line
> rather than formatted json - fix that.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Applied, thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
