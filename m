From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] acpi/nfit: Fix bus command validation
Date: Mon, 11 Feb 2019 17:26:19 +0000
Message-ID: <20190211172620.A7A13222A0@mail.kernel.org>
References: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2017993269399251147=="
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <154958385172.3932544.193235520333886200.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Vishal Verma <vishal.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

--===============2017993269399251147==
Content-Type: text/plain

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 11189c1089da acpi/nfit: Fix command-supported detection.

The bot has tested the following trees: v4.20.7, v4.19.20, v4.14.98, v4.9.155.

v4.20.7: Build OK!
v4.19.20: Build OK!
v4.14.98: Build failed! Errors:
    drivers/acpi/nfit/core.c:261:21: error: ‘nfit_mem’ undeclared (first use in this function)

v4.9.155: Failed to apply! Possible dependencies:
    37d74841b9d4 ("acpi, nfit: Enable DSM pass thru for root functions.")
    7db5bb33add5 ("libnvdimm, acpi, nfit: Add bus level dsm mask for pass thru.")


How should we proceed with this patch?

--
Thanks,
Sasha

--===============2017993269399251147==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--===============2017993269399251147==--
