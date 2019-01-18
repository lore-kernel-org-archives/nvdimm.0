From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] acpi/nfit: Block function zero DSMs
Date: Fri, 18 Jan 2019 15:01:38 +0000
Message-ID: <20190118150138.C162C2087E@mail.kernel.org>
References: <154751742931.1617064.12104834083206585656.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <154751742931.1617064.12104834083206585656.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stuart hayes <stuart.w.hayes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: e02fb7264d8a nfit: add Microsoft NVDIMM DSM command set to white list.

The bot has tested the following trees: v4.20.2, v4.19.15, v4.14.93, v4.9.150.

v4.20.2: Build OK!
v4.19.15: Build OK!
v4.14.93: Build OK!
v4.9.150: Failed to apply! Possible dependencies:
    41c8bdb3ab10 ("acpi, nfit: Switch to use new generic UUID API")


How should we proceed with this patch?

--
Thanks,
Sasha
