From: "bipin.tomar-/E1597aS9LQAvxtiuMwx3w@public.gmane.org" <bipin.tomar-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Fw: Why only devdax guarantees guest data persistence ?
Date: Tue, 19 Feb 2019 17:21:49 +0000 (UTC)
Message-ID: <1924469947.1654149.1550596909762@mail.yahoo.com>
References: <729515484.1572396.1550250571940.ref@mail.yahoo.com>
 <729515484.1572396.1550250571940@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <729515484.1572396.1550250571940-sAHhhX/85wgbqTNvkayDYw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

 I haven't heard from anyone on qemu-devel. There are a lot of vNVDIMM experts here and I'm hoping that someone here may throw some light.

-BT

   ----- Forwarded Message ----- From: bipin.tomar-/E1597aS9LQAvxtiuMwx3w@public.gmane.org <bipin.tomar-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>To: qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>Sent: Friday, February 15, 2019, 12:09:31 PM ESTSubject: Why only devdax guarantees guest data persistence ?
 Text from "docs/nvdimm.txt" says:
Guest Data Persistence
----------------------

Though QEMU supports multiple types of vNVDIMM backends on Linux,
currently the only one that can guarantee the guest write persistence
is the device DAX on the real NVDIMM device (e.g., /dev/dax0.0), to
which all guest access do not involve any host-side kernel cache.

I think here "host-side kernel cache" imply "page cache". Why does fsdax NOT have the same persistence guarantees as devdax for vNVDIMM?
Both the modes avoid using page cache then why is devdax explicitly called out?
-BT
