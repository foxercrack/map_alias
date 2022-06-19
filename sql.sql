--
-- Table structure for table `alias`
--

CREATE TABLE `alias` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `text` varchar(200) NOT NULL,
  `target` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `alias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;
