Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM04-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam04olkn0826.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe4c::826])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4550321D147D9
 for <linux-nvdimm@lists.01.org>; Tue, 11 Jul 2017 08:09:00 -0700 (PDT)
From: lee fei <louis0126@live.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 11 Jul 2017 15:10:29 +0000
Message-ID: <MWHPR13MB1662CB877061C3565DCF1A6FCAAE0@MWHPR13MB1662.namprd13.prod.outlook.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

hello everyone

I=92m trying to enable GPU ( Nvidia's GPU ) P2P in a KVM VM. The two GPUs a=
re under a PCIe switch and it could do P2P in the host. But  it could not d=
o GPU P2P even it could pass the [09/22] PCI: Add pci_peer_traffic_supporte=
d() (https://patchwork.kernel.org/patch/7188701/) function detection in
[09/22] PCI: Add pci_peer_traffic_supported() - Patchwork<https://patchwork=
.kernel.org/patch/7188701/>
patchwork.kernel.org
Add checks for topology and ACS configuration to determine whether or not p=
eer traffic should be supported between two PCI devices. Signed-off-by: Wil=
l Davis



 A P2P DMA DMA-API/PCI map_peer_resource support for peer-to-peer
    http://www.spinics.net/lists/linux-pci/msg44560.html

[PATCH 00/22] DMA-API/PCI map_peer_resource support for ...<http://www.spin=
ics.net/lists/linux-pci/msg44560.html>
www.spinics.net
Linux PCI Bus: [PATCH 00/22] DMA-API/PCI map_peer_resource support for peer=
-to-peer


So I=92m thinking would this thread take this situation ( virtualization sc=
enario ) into consideration? How could we judge whether it could support P2=
P in a KVM ( or XEN etc ) VM?

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
